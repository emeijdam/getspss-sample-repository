import pandas as pd
import requests


def get_odata(target_url):
    data = pd.DataFrame()
    while target_url:
        r = requests.get(target_url).json()
        data = data.append(pd.DataFrame(r['value']))
        if '@odata.nextLink' in r:
            target_url = r['@odata.nextLink']
        else:
            target_url = None
            
    return data


table_url = "https://odata4.cbs.nl/CBS/83765NED"

target_url = table_url + "/Observations"
data = get_odata(target_url)
print(data.head())