#數字運算
x = 9-6
x = 9/6
#整數除法
x = 9//6
#次方
x = 2**3
#餘數
x = 7%4
x = x + 1
x -= 2
print(x)

# 字串運算
# 字串會對內部的字元編號.從0開始算起
s = "Hel\"lo" + " World" * 3
# 空白可連接字串
x = "Hello" " World" * 3
print(s)
print(x[1:4])
print(x[:4])

# 集合的運算
s1 = {2,3,5,4,6}
s2 = {5,6,7,8}
#print(10 in s1)
s3 = s1&s2 #交集
s3 = s1|s2 #聯集
s3 = s1-s2 #差集
s3 = s1^s2 #反交集
#print(s3)
s = set("Hello")    #拆解字串
#print(s)

# 字典的運算
dic={"apple":"蘋果","bug":"蟲"}
del dic["apple"]
#print(dic)

dic = {x:x*2 for x in [3,6,8]}
print(dic)