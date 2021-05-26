from dagster import pipeline, repository, schedule, solid


@solid
def hello():
    return 1


@pipeline
def my_pipeline():
    hello()


@schedule(cron_schedule="* * * * *", pipeline_name="my_pipeline", execution_timezone="US/Central")
def my_schedule(_context):
    return {}

@solid
def asd():
    return 2

@pipeline
def asd_pipeline():
    asd()

@repository
def deploy_docker_repository():
    return [my_pipeline, asd_pipeline, my_schedule]
