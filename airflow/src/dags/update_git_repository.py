from airflow import DAG
from airflow.utils.dates import days_ago
from airflow.operators.bash_operator import BashOperator

bash_cmd = """
DAGS_PATH='{{var.value.git_path}}'
GIT_URL='{{var.value.git_url}}'

mkdir -p "$DAGS_PATH"

cd "$DAGS_PATH"

if [ -d "$DAGS_PATH/.git" ]; then
  GIT_SSH_COMMAND='ssh -o StrictHostKeyChecking=no -i /run/secrets/ssh_github_dags' git pull
else
  git init
  GIT_SSH_COMMAND='ssh -o StrictHostKeyChecking=no -i /run/secrets/ssh_github_dags' git remote add -f origin $GIT_URL
  git checkout master
  git merge origin/master --allow-unrelated-histories
fi

"""

with DAG(
    dag_id="update_git_repository",
    start_date=days_ago(0),
    schedule_interval='@once',
    tags=['github', 'dags'],
) as parent_dag:
    task = BashOperator(task_id="parent_task",
                        bash_command=bash_cmd,
                        env={})

