# Changelog

## [1.4.0](https://github.com/cloudquery/policies-premium/compare/transformation-aws-compliance-premium-v1.3.0...transformation-aws-compliance-premium-v1.4.0) (2024-02-06)


### Features

* Added AWS Compliance CIS version 2.0.0 ([#551](https://github.com/cloudquery/policies-premium/issues/551)) ([852af57](https://github.com/cloudquery/policies-premium/commit/852af570ae8427e2dcdc6926b4d3938e5c671038))

## [1.3.0](https://github.com/cloudquery/policies-premium/compare/transformation-aws-compliance-premium-v1.2.0...transformation-aws-compliance-premium-v1.3.0) (2024-02-01)


### Features

* Added queries for Foundational Security compliance for BigQuery ([#533](https://github.com/cloudquery/policies-premium/issues/533)) ([3256953](https://github.com/cloudquery/policies-premium/commit/32569539503f85d9eb325244def7a8db07616694))


### Bug Fixes

* **deps:** Update dependency dbt-bigquery to v1.7.3 ([#555](https://github.com/cloudquery/policies-premium/issues/555)) ([e1ef22b](https://github.com/cloudquery/policies-premium/commit/e1ef22b09347ca7663ec3829aa730327a6c9e3f0))
* **deps:** Update dependency dbt-postgres to v1.7.6 ([#556](https://github.com/cloudquery/policies-premium/issues/556)) ([01d83c3](https://github.com/cloudquery/policies-premium/commit/01d83c3589be42468fb3e93ac9aae1b270f60e25))
* Update documentation ([#527](https://github.com/cloudquery/policies-premium/issues/527)) ([b009951](https://github.com/cloudquery/policies-premium/commit/b009951492cf9d1836110ad4bf8346b40a0ec1af))
* Use `registry: cloudquery` for Snowflake tests ([#541](https://github.com/cloudquery/policies-premium/issues/541)) ([087a4ce](https://github.com/cloudquery/policies-premium/commit/087a4cecefdb28a1f29fe7c5d741b3c6ea19a27b))

## [1.2.0](https://github.com/cloudquery/policies-premium/compare/transformation-aws-compliance-premium-v1.1.0...transformation-aws-compliance-premium-v1.2.0) (2024-01-24)


### Features

* Added queries for Foundational Security compliance for bigquery ([#515](https://github.com/cloudquery/policies-premium/issues/515)) ([5209331](https://github.com/cloudquery/policies-premium/commit/52093318ffcce00471062a6e31a36d2ada6cae7b))

## [1.1.0](https://github.com/cloudquery/policies-premium/compare/transformation-aws-compliance-premium-v1.0.1...transformation-aws-compliance-premium-v1.1.0) (2024-01-23)


### Features

* Add helpful dbt set up notes to aws free and premium readme ([#517](https://github.com/cloudquery/policies-premium/issues/517)) ([185e4b8](https://github.com/cloudquery/policies-premium/commit/185e4b89827693920c000a131152c843eed3b97b))

## [1.0.1](https://github.com/cloudquery/policies-premium/compare/transformation-aws-compliance-premium-v1.0.0...transformation-aws-compliance-premium-v1.0.1) (2024-01-22)


### Bug Fixes

* Updated APIGateway Method Settings macro to handle multiple methods ([#511](https://github.com/cloudquery/policies-premium/issues/511)) ([fdeac11](https://github.com/cloudquery/policies-premium/commit/fdeac11a029078feb4990b72600ea39e628bca04))

## [1.0.0](https://github.com/cloudquery/policies-premium/compare/transformation-aws-compliance-premium-v0.5.0...transformation-aws-compliance-premium-v1.0.0) (2024-01-17)


### ⚠ BREAKING CHANGES

* Update `aws` to `v23.3.1` ([#264](https://github.com/cloudquery/policies-premium/issues/264))

### Features

* Added queries for AWS Foundational Security for Postgres - Premium ([#451](https://github.com/cloudquery/policies-premium/issues/451)) ([a2f23f0](https://github.com/cloudquery/policies-premium/commit/a2f23f0dd0e7e81d3e25fd0029999c6762c49faa))
* Added queries for bigquery pci_dss ([#325](https://github.com/cloudquery/policies-premium/issues/325)) ([3a6a500](https://github.com/cloudquery/policies-premium/commit/3a6a5003aed9e082e709999f1bac2c766f6951a4))
* Added queries for bigquery publicly_available, public_egress, i… ([#329](https://github.com/cloudquery/policies-premium/issues/329)) ([52458f7](https://github.com/cloudquery/policies-premium/commit/52458f7b272d8cd20c3c096d990b10098e8266e1))
* Update `aws` to `v23.3.1` ([#264](https://github.com/cloudquery/policies-premium/issues/264)) ([d361f9b](https://github.com/cloudquery/policies-premium/commit/d361f9bad529167e093c0eca56fc9923adc72fca))


### Bug Fixes

* **deps:** Update dependency dbt-postgres to v1.7.4 ([#473](https://github.com/cloudquery/policies-premium/issues/473)) ([a7f759a](https://github.com/cloudquery/policies-premium/commit/a7f759aaf50a0a9e308fd6be378811a0097925c2))
* **deps:** Update dependency dbt-snowflake to v1.7.1 ([#474](https://github.com/cloudquery/policies-premium/issues/474)) ([d16c2f2](https://github.com/cloudquery/policies-premium/commit/d16c2f29a30e7be5c5d52b02f6fd041e75e0fa9e))

## [0.5.0](https://github.com/cloudquery/policies-premium/compare/transformation-aws-compliance-premium-v0.4.0...transformation-aws-compliance-premium-v0.5.0) (2023-12-27)


### Features

* Trigger GCP Free Build Transformations ([5c68bae](https://github.com/cloudquery/policies-premium/commit/5c68bae0f30e4e57db5774300488d4b6ddd42c3b))
* Trigger GCP Free Build Transformations ([#385](https://github.com/cloudquery/policies-premium/issues/385)) ([5c68bae](https://github.com/cloudquery/policies-premium/commit/5c68bae0f30e4e57db5774300488d4b6ddd42c3b))
* Update AWS Free and Premium Compliance readmes ([a54c7db](https://github.com/cloudquery/policies-premium/commit/a54c7dbedca502bc6d11baccef51dbb3af5662ea))
* Update AWS Free and Premium Compliance readmes ([#420](https://github.com/cloudquery/policies-premium/issues/420)) ([a54c7db](https://github.com/cloudquery/policies-premium/commit/a54c7dbedca502bc6d11baccef51dbb3af5662ea))


### Bug Fixes

* Link to latest versions in README ([#428](https://github.com/cloudquery/policies-premium/issues/428)) ([44901a2](https://github.com/cloudquery/policies-premium/commit/44901a2be3ada54606fc928010ae9a15aaff7173))
* Updated dbt_run without specifying the model ([#422](https://github.com/cloudquery/policies-premium/issues/422)) ([b7ff919](https://github.com/cloudquery/policies-premium/commit/b7ff91978bd67ef1b859d6aaa012beef1ea84181))

## [0.4.0](https://github.com/cloudquery/policies-premium/compare/transformation-aws-compliance-premium-v0.3.0...transformation-aws-compliance-premium-v0.4.0) (2023-12-07)


### Features

* Update profiles and requirements for BigQuery and AWS Compliance ([3b27992](https://github.com/cloudquery/policies-premium/commit/3b279927f36fec115535463c403ff887e8b4f812))
* Update profiles and requirements for BigQuery and AWS Compliance ([#381](https://github.com/cloudquery/policies-premium/issues/381)) ([3b27992](https://github.com/cloudquery/policies-premium/commit/3b279927f36fec115535463c403ff887e8b4f812))

## [0.3.0](https://github.com/cloudquery/policies-premium/compare/transformation-aws-compliance-premium-v0.2.2...transformation-aws-compliance-premium-v0.3.0) (2023-12-07)


### Features

* Update Readme and requirements for AWS Compliance to include BigQuery ([#377](https://github.com/cloudquery/policies-premium/issues/377)) ([0609eca](https://github.com/cloudquery/policies-premium/commit/0609eca392f6e6c33e99d8963ef43a55b1ea502c))
* Update Readme and requirements for AWS Compliance to include BigQuery ([#377](https://github.com/cloudquery/policies-premium/issues/377)) ([0609eca](https://github.com/cloudquery/policies-premium/commit/0609eca392f6e6c33e99d8963ef43a55b1ea502c))

## [0.2.2](https://github.com/cloudquery/policies-premium/compare/transformation-aws-compliance-premium-v0.2.1...transformation-aws-compliance-premium-v0.2.2) (2023-12-05)


### Bug Fixes

* Updated aws_dbt name of models ([#312](https://github.com/cloudquery/policies-premium/issues/312)) ([02359eb](https://github.com/cloudquery/policies-premium/commit/02359eb5a372f139970198f8975d29119c2a0e09))

## [0.2.1](https://github.com/cloudquery/policies-premium/compare/transformation-aws-compliance-premium-v0.2.0...transformation-aws-compliance-premium-v0.2.1) (2023-12-01)


### Bug Fixes

* **deps:** Update dependency dbt-postgres to v1.7.3 ([#313](https://github.com/cloudquery/policies-premium/issues/313)) ([caaa770](https://github.com/cloudquery/policies-premium/commit/caaa770ed3ea2b4285a2d4af851bb05f1449e9b0))
* **deps:** Update dependency dbt-snowflake to v1.7.0 ([#314](https://github.com/cloudquery/policies-premium/issues/314)) ([f25f666](https://github.com/cloudquery/policies-premium/commit/f25f666163dc65cd7ba1ed067a531b48fff3a729))

## [0.2.0](https://github.com/cloudquery/policies-premium/compare/transformation-aws-compliance-premium-v0.1.2...transformation-aws-compliance-premium-v0.2.0) (2023-11-30)


### Features

* Added AWS Bigquery dbt - cis v1.2.0 ([#299](https://github.com/cloudquery/policies-premium/issues/299)) ([ecc5fde](https://github.com/cloudquery/policies-premium/commit/ecc5fdec4cac7056ceeee412f303cbfcf695483e))


### Bug Fixes

* Updated aws_fsbp ([#310](https://github.com/cloudquery/policies-premium/issues/310)) ([2377baa](https://github.com/cloudquery/policies-premium/commit/2377baabb3d515bdf5564f4ae08b151d57938ed3))

## [0.1.2](https://github.com/cloudquery/policies-premium/compare/transformation-aws-compliance-premium-v0.1.1...transformation-aws-compliance-premium-v0.1.2) (2023-11-28)


### Bug Fixes

* Update docs ([#280](https://github.com/cloudquery/policies-premium/issues/280)) ([d3ad35b](https://github.com/cloudquery/policies-premium/commit/d3ad35bc6ac54875e124632194e38b04e490bec9))

## [0.1.1](https://github.com/cloudquery/policies-premium/compare/transformation-aws-compliance-premium-v0.1.0...transformation-aws-compliance-premium-v0.1.1) (2023-11-22)


### Bug Fixes

* Update `pro/enabled_all_regions.sql` ([#265](https://github.com/cloudquery/policies-premium/issues/265)) ([95bf4bd](https://github.com/cloudquery/policies-premium/commit/95bf4bdffcd1104343f3a632ee65e40af0b68c41))

## [0.1.0](https://github.com/cloudquery/policies-premium/compare/transformation-aws-compliance-premium-v0.0.1...transformation-aws-compliance-premium-v0.1.0) (2023-11-20)


### Features

* Add execution time to all policies ([#191](https://github.com/cloudquery/policies-premium/issues/191)) ([0aa735e](https://github.com/cloudquery/policies-premium/commit/0aa735ee397a1f290a1226df378e25d4050289f9))


### Bug Fixes

* Pack free marcos and shared models ([#255](https://github.com/cloudquery/policies-premium/issues/255)) ([2c56aac](https://github.com/cloudquery/policies-premium/commit/2c56aac6e484872f50d0b27b57ff1407da5c5621))

## 0.0.1 (2023-11-20)


### Features

* Add All Queries from AWS Plugin ([#166](https://github.com/cloudquery/policies-premium/issues/166)) ([b9f2782](https://github.com/cloudquery/policies-premium/commit/b9f2782357af336480ab51f5497cd64b6b71a81d))
* DBT tests ([#159](https://github.com/cloudquery/policies-premium/issues/159)) ([9544114](https://github.com/cloudquery/policies-premium/commit/9544114af0cf08fbf6e2c18f32fc609c9b5e0bf3))
* Updated query instances_should_have_association_compliance_stat… ([#175](https://github.com/cloudquery/policies-premium/issues/175)) ([41a0a6c](https://github.com/cloudquery/policies-premium/commit/41a0a6c1e5bc233f6d0ee8692ea932d67f32bf1d))
* Updated query macro autoscale_or_ondemand ([#178](https://github.com/cloudquery/policies-premium/issues/178)) ([8cbf273](https://github.com/cloudquery/policies-premium/commit/8cbf2730b4fd05f6fb69aa26855fa560955818a6))


### Miscellaneous Chores

* release 0.0.1 ([2e9e699](https://github.com/cloudquery/policies-premium/commit/2e9e6995991e12f4e6df7b73e6f7d662b0f56430))
