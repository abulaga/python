import urllib.request as request
src="https://www.ntu.edu.tw/"
with request.urlopen(src) as response:
    # data = response.read()   #取得台灣大學網站原始碼(html,css,js)    
    data = response.read().decode("utf-8")   #取得台灣大學網站原始碼(html,css,js)
print(data)

#=====================================================================
import urllib.request as request
import json #使用json模組
src="https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=24c9f8fe-88db-4a6e-895c-498fbc94df94"
with request.urlopen(src) as response:
    data = json.load(response)  #利用json模組處理json資料

clist=data["result"]["results"]
with open("data.txt","w",encoding="utf-8") as file:
    for company in clist:
        # print(company["o_tlc_agency_name"])
        file.write(company["o_tlc_agency_name"]+"\n")
