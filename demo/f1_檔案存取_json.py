#儲存檔案   讀取模式 - r
#          寫入模式 - w
#          讀寫模式 - r+
file=open("data.txt",mode="w" ,encoding="utf-8")
file.write("Hello File 測試中文")
file.close()

with open("data.txt",mode="w" ,encoding="utf-8") as file:
    file.write("5\n3\n1")

#讀取檔案
sum = 0
with open("data.txt",mode="r",encoding="utf-8") as file:
    for line in file:   #一行一行讀
        sum+=int(line)
print(sum)


#使用json
import json
with open("config.json",mode="r") as file:
    data=json.load(file)
print(data)
# print("name: ",data["name"])
# print("version: ",data["verson"])

data["name"] = "New Name"
with open("config.json",mode="w") as file:
    json.dump(data,file)