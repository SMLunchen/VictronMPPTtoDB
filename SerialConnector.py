#!/usr/bin/python
# -*- coding: utf-8 -*-
import serial
import time

class SerialConnector():
    SerialPointer = None
    ReadTimestamp = None
    InitialTimestampDelay = 10

    def __init__(self, portName, baud, timeout=1):
        self._portName = portName
        self._baud = baud
        self._timeout = timeout

        self.SerialPointer = serial.Serial(portName, baud, timeout=timeout)
        self.ReadTimestamp = time.time() + self.InitialTimestampDelay

    def Read(self):
        # if nothing to read, sleep for x milliseconds and check timeout
        while self.SerialPointer.inWaiting() == 0:
            time.sleep(0.01)
            if(self.ReadTimestamp + 5 < time.time()):
                print "Reconnect...", self._portName
                self.SerialPointer.close()
                time.sleep(1)
                self.SerialPointer = serial.Serial(self._portName, self._baud, timeout=self._timeout)
                self.ReadTimestamp = time.time() + self.InitialTimestampDelay
        return self.SerialPointer.readline().rstrip()

    def Validate(self, line):
        if(len(line) <= 1):
            return None

        data = line.split("|")
        if(len(data) <= 1):
            return None

        self.ReadTimestamp = time.time()
        return data

    def Write(self, data):
        if(data is not None):
            self.SerialPointer.write("{0};".format(data))
            self.SerialPointer.flush()

    def Disconnect(self):
        self.SerialPointer.close()
        time.sleep(1)
