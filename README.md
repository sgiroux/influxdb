# influxdb

A simple docker image that provides basic influxdb functionality while adding the ability to backup/restore to an s3 bucket and a healthcheck mechanism.

Environment variables:

AWS_ACCESS_KEY_ID - The AWS access key used to access the s3 bucket

AWS_SECRET_ACCESS_KEY - The AWS secret key used to access the s3 bucket

AWS_DEFAULT_REGION - The AWS region where the s3 bucket resides

AWS_BUCKET_NAME - The name of the AWS s3 bucket where backups will live

HEALTH_CHECK_URL - The URL of the healthcheck that gets pinged upon a successful backup.
