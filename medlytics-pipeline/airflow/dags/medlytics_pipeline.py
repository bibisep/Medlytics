from datetime import datetime

from airflow import DAG
from airflow.providers.standard.operators.bash import BashOperator


with DAG(
    dag_id="medlytics_pipeline",
    start_date=datetime(2026, 1, 1),
    schedule=None,
    catchup=False,
    tags=["medlytics", "cnes", "etl"],
) as dag:

    analisar_cnes = BashOperator(
        task_id="analisar_cnes",
        bash_command="python /opt/airflow/scripts/analise_cnes.py",
    )

    executar_etl = BashOperator(
        task_id="executar_etl",
        bash_command="python /opt/airflow/scripts/etl_cnes.py",
    )

    validar_gold = BashOperator(
        task_id="validar_gold",
        bash_command="python /opt/airflow/scripts/validacao_gold.py",
    )

    analisar_cnes >> executar_etl >> validar_gold