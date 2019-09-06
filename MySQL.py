#!/usr/bin/python
# -*- coding: utf-8 -*-
import mysql.connector


class MySQL(object):

    __Database = None

    def __init__(self):

        database = "solarstats"
        password = "password"
        host = "127.0.0.1"
        user = "root"

        self.__Database = self.GetDB(database, user, password, host)

    def GetDB(self, database, user="root", passwd=None, host="127.0.0.1"):
        return mysql.connector.connect(user=user, password=passwd, host=host, database=database)

    def Execute(self, sql):
        return self.ExecuteDB(self.__Database, sql)

    def ExecuteDB(self, db, sql):
        cur = db.cursor()
        cur.execute(sql)
        return cur

    def Fetchall(self, sql, index=None):
        return self.FetchallDB(self.__Database, sql, index)

    def FetchallCacheBreaker(self, sql, index=None):
        return self.FetchallDB(self.__Database, sql, index)

    def FetchallDB(self, db, sql, index=None):
        result = []
        for row in self.ExecuteDB(db, sql).fetchall():
            if index is not None:
                row = row[index]
            result.append(row)
        return result


    def Disconnect(self):
        self.DisconnectDB(self.__Database)

    def DisconnectDB(self, db):
        db.close()

