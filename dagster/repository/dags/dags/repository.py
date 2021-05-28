from dagster import repository

from dags.pipelines.my_pipeline import another_pipeline
from dags.schedules.my_hourly_schedule import my_hourly_schedule
from dags.sensors.my_sensor import my_sensor


@repository
def dags():
    """
    The repository definition for this dags Dagster repository.

    For hints on building your Dagster repository, see our documentation overview on Repositories:
    https://docs.dagster.io/overview/repositories-workspaces/repositories
    """
    pipelines = [another_pipeline]
    schedules = [my_hourly_schedule]
    sensors = [my_sensor]

    return pipelines + schedules + sensors
