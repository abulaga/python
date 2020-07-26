# 建立實體物件
class Point1:
    def __init__(self):
        self.x2=4
        self.y2=5
        #封裝在實體物件中的變數
        #此實體物件包函x和y兩個實體屬性

# 建立時，可直接傳入參數資料
class Point:
    def __init__(self, x, y):
        self.x=x
        self.y=y
# 建立實體物件，並取得實體屬性資料
p=Point(1, 5)
print(p.x+p.y)

#範例
class File:
    def __init__(self,name):
        self.name = name
        self.file = None #尚未開啟檔案: 初始是 None
    def open(self):
        self.file= open(self.name,mode="r",encoding="utf-8")
    def read(self):
        return self.file.read()

f1=File("data.txt")
f1.open()
print(f1.read())  