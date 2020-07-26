import urllib.request as req
import bs4
import pandas as pd
def getdata(url):
    request=req.Request(url)

    with req.urlopen(request) as response:
        data=response.read().decode("utf-8")

    root=bs4.BeautifulSoup(data,"html.parser")
    #抓目標Table
    table=root.find("table",{"class":"auto-style1","style":"border-style: groove"})

    #第一筆別抓
    row_data=table.find_all("tr")[1:] 

    final_data=list()
    #每一筆資料
    for tr in row_data:
        item=list() #清空
        #各欄位資料
        td=tr.find_all("td")
        for data in td:
            
            if data["style"] == "border-style: groove; font-size: medium;font-weight:800":                
                data=data.text.replace('\r\n','')#去換行
                data_list=data.split(",")
                for data_item in data_list:            
                    data_item=data_item.strip()
                    item.append(data_item)
                continue
            item.append(data.text)
        final_data.append(item)
    
    ls_date=list()
    num1=list();num2=list();num3=list();num4=list();num5=list();num6=list()
    num_sp=list()
    for final_data_item in final_data:
        ls_date.append(final_data_item[0])
        num1.append(final_data_item[1])
        num2.append(final_data_item[2])
        num3.append(final_data_item[3])
        num4.append(final_data_item[4])
        num5.append(final_data_item[5])
        num6.append(final_data_item[6])
        num_sp.append(final_data_item[7])

    df={"date":ls_date,
        "num1":num1,
        "num2":num2,
        "num3":num3,
        "num4":num4,
        "num5":num5,
        "num6":num6,
        "num_sp":num_sp,
    }  #建立df格式
    select_df=pd.DataFrame(df)

    next_url=root.find("a",string="下一頁")
    return next_url["href"],select_df 

sourse="listltobig.asp"
final_df=pd.DataFrame()
for times in range(5):
    sourse,get_df=getdata("https://www.lotto-8.com/Taiwan/"+sourse)
    final_df=final_df.append(get_df,ignore_index=True)
print(final_df)
final_df.to_csv('Result.csv')
   