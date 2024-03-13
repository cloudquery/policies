module.exports = async ({github, context}) => {
    const files = process.env.FILES.split(' ')
    console.log(files)
    if (files.length >= 300) {
        // This is a GitHub limitation https://github.com/cloudquery/cloudquery/issues/2688
        throw new Error('Too many files changed. Skipping check. Please split your PR into multiple ones.')
    }

    const path = require("path");
    const fs = require("fs");
    let now = new Date().getTime()
    const deadline = now + 60 * 1000 * 50
    const matchesWorkflow = (file, action) => {
        if (!file.startsWith('.github/workflows/')) {
            return false
        }
        try {
            const contents = fs.readFileSync(file, 'utf8');
            return contents.includes(`"${action}/`)
        } catch {
            return false
        }
    }
    const matchesFile = (action) => {
        return files.some(file => file.startsWith(`${action}/`) || matchesWorkflow(file, action))
    }

    const testAll = files.includes("scripts/workflows/wait_for_required_workflows.js") || files.includes(".github/workflows/wait_for_required_workflows.yml")
    const transformations = fs.readdirSync("transformations", {withFileTypes: true, recursive: true}).filter(dirent => dirent.isFile() && dirent.name === "dbt_project.yml").map(dirent => dirent.path)
    let actions = transformations.filter(action => testAll || matchesFile(action))
    if (actions.length === 0) {
        console.log("No actions to wait for")
        return
    }

    pendingActions = [...actions]
    console.log(`Waiting for ${pendingActions.join(", ")}`)
    while (now <= deadline) {
        const checkRuns = await github.paginate(github.rest.checks.listForRef, {
            owner: 'cloudquery',
            repo: context.repo.repo,
            ref: context.payload.pull_request.head.sha,
            status: 'completed',
            per_page: 100
        })
        const runsWithPossibleDuplicates = checkRuns.map(({id, name, conclusion}) => ({id, name, conclusion}))
        const runs = runsWithPossibleDuplicates.filter((run, index, self) => self.findIndex(({id}) => id === run.id) === index)
        console.log(`Got the following check runs: ${JSON.stringify(runs)}`)
        const matchingRuns = runs.filter(({name}) => actions.includes(name))
        const failedRuns = matchingRuns.filter(({conclusion}) => conclusion !== 'success')
        if (failedRuns.length > 0) {
            throw new Error(`The following required workflows failed: ${failedRuns.map(({name}) => name).join(", ")}`)
        }
        console.log(`Matching runs: ${matchingRuns.map(({name}) => name).join(", ")}`)
        console.log(`Actions: ${actions.join(", ")}`)
        if (matchingRuns.length === actions.length) {
            console.log("All required workflows have passed")
            return
        }
        pendingActions = actions.filter(action => !runs.some(({name}) => name === action))
        console.log(`Waiting for ${pendingActions.join(", ")}`)
        await new Promise(r => setTimeout(r, 60000));
        now = new Date().getTime()
    }
    throw new Error(`Timed out waiting for ${pendingActions.join(', ')}`)
}
