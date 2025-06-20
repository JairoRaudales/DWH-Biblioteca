import schedule
import time
import subprocess


def job():
    subprocess.run(["python", "C:\proyectos\etlmongooracle.py"])


schedule.every().day.at("10:36").do(job)

while True:
    schedule.run_pending()
    time.sleep(60)
    