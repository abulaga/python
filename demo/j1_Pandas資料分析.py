import pandas as pd #載入pandas模組
# ==============單維度的資料 Series=================
#建立Series 
data= pd.Series([20,10,15])
#基本Series
print(data)
print("Max",data.max())
print("Median",data.median())
data=data*2
print(data)
data=data==20
print(data)

#資料索引
data=pd.Series([4,2,-5,5,6],index=["a","b","c","d","e"])
# print(data)

#觀察資料
# print("資料型態",data.dtype)
# print("資料數量",data.size)
# print("資料索引",data.index)

#取得資料
# print(data[2])
# print(data["d"],data["e"])

#數字運算:基本,統計,順序
# print("最大值",data.max())
# print("總和",data.sum())
# print("標準差",data.std())
# print("中位數",data.median())
# print("最大的三個數",data.nlargest(3))

data=pd.Series(["您好","Python","Pandas"])
#字串運算:基本,串接,搜尋,取代
# print(data.str.lower())   #全部變小寫
# print(data.str.len())   #字串長度
# print(data.str.cat(sep=","))    #把字串串起來，可以自訂串接符號
# print(data.str.contains("P"))   #判斷每個字串是否包含特定字元
print(data.str.replace("您好","Hello"))

# ==============雙維度的資料 DataFrame=================
# 以字典資料為底，建立 DataFrame
data=pd.DataFrame({
    "name":["Amy","Jhon","Bob"],
    "salary":[30000,50000,40000]
})
print(data)
#取特定欄位
# print(data["salary"])
print("=====================")
#取特定的列(印出第一列)
print(data.iloc[0])