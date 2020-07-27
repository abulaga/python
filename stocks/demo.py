#!/usr/bin/python
# -*- coding: utf-8 -*-

# 引入 MySQLdb 模組，提供連接 MySQL 的功能

import pymysql
# 連接 MySQL 資料庫
db = pymysql.connect(host="localhost",
    user="root", passwd="root", db="stocks")

# 使用cursor()方法獲取操作游標
cursor = db.cursor()

# sql = "insert into stocks.demo (id,memo) values (4,'d')"
sql = "update stocks.demo set memo = 'aa' where id = 1"

# 執行sql語句

try:
  #執行sql語句
  cursor.execute(sql)
  #提交到資料庫執行
  db.commit()
except Exception as e:
  print(e)
  db.rollback()

# 執行 MySQL 查詢指令
cursor.execute("SELECT * FROM demo")

# 取回所有查詢結果
results = cursor.fetchall()

# 輸出結果
for record in results:
  col1 = record[0]
  col2 = record[1]
  print(col1,col2)

# print(results)
# 關閉連線
db.close()