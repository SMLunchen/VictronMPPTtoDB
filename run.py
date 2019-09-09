#!/usr/bin/python
# -*- coding: utf-8 -*-
#importy stuff
import MySQL
import SerialConnector
#cleans line and maps variables
def cleanLine(dataLine, lineName, lineVar):
    if(dataLine.startswith(lineName)):
        lineVar = dataLine.replace(lineName, "").strip()
    return lineVar
    

def run():
    #Connect Serial Port
    serialConnect = SerialConnector.SerialConnector("/dev/ttyUSB0", 19200)
	#connect Mysql
    sqlConnect = MySQL.MySQL()

    #Product ID
    PID= ""
	#Firmware Version
    FW= ""
	#SerialNr
    SER= ""
	#Main Battery Channel Voltage in mV
    V= ""
	#Main Battery Channel Current in mA
    I= ""
	#Solar Panel Voltage in mV
    VPV= ""
	#Solar Panel Power in W
    PPV= ""
	#Charger State
	# 0 -> Off
	# 1 -> Low Power
	# 2 -> Fault
	# 3 -> Bulk
	# 4 -> Absorption
	# 5 -> Float
	# 6 -> Storage
	# 7 -> Equalize (manuel)
	# 9 -> Inverting
	# 11 -> Power Supply
	# 245 -> Startup
	# 246 -> Repeated absorption
	# 247 -> Auto equalize /recondition
	# 248 -> Battery Safe
	# 252 -> External Control
    CS= ""
	#MPPT Mode
	# 0 -> Off
	# 1 -> Voltage or current limited
	# 2 -> MPP Tracker active
    MPPT= ""
	#Charger Errorcode
    ERR= ""
	#Load output state on/off
    LOAD= ""
	#Load current in mA
    IL= ""
	#Yield total (user resettable counter) in 0.01kWh
    H19= ""
	#Yield total in 0.01 kWh
    H20= ""
	#Maximum power today in W
    H21= ""
	#Yield yestarday in 0.01kWh
    H22= ""
	#Maximum power yesterday in W
    H23= ""
	#Day sequence number - a changed number means a new day  (this implies historic data changed)
    HSDS= ""
	#Checksum not being taken into account (yet)
    Checksum = ""

    beginFound = False
    run = True

    while run:
        try:
            line = serialConnect.Read()
        except IOError:
            return
        
        data = serialConnect.Validate(line)
        if(data is None):
            continue

        if(not beginFound and not data.startswith("PID")):
            continue
        
		#listen for PID then start recording data
        if(data.startswith("PID")):
            beginFound = True
        
		#pre populate variables
        PID = cleanLine(data, "PID", PID)
        FW = cleanLine(data, "FW", FW)
        SER = cleanLine(data, "SER", SER)
        V = cleanLine(data, "V	", V)
        I = cleanLine(data, "I	", I)
        VPV = cleanLine(data, "VPV", VPV)
        PPV = cleanLine(data, "PPV", PPV)
        CS = cleanLine(data, "CS", CS)
        MPPT = cleanLine(data, "MPPT", MPPT)
        ERR = cleanLine(data, "ERR", ERR)
        LOAD = cleanLine(data, "LOAD", LOAD)
        IL = cleanLine(data, "IL", IL)
        H19 = cleanLine(data, "H19", H19)
        H20 = cleanLine(data, "H20", H20)
        H21 = cleanLine(data, "H21", H21)
        H22 = cleanLine(data, "H22", H22)
        H23 = cleanLine(data, "H23", H23)
        HSDS = cleanLine(data, "HSDS", HSDS)
        Checksum = cleanLine(data, "Checksum", Checksum)

        #listen for Checksum to end recording
        if(data.startswith("Checksum")):
            run = False
            # write to DB
            #print PID, FW, SER, V, I, VPV, PPV, CS, MPPT, ERR, LOAD, IL, H19, H20, H21, H22, H23, HSDS, Checksum
			#Voltage is in mV. Convert.
            V = float(V)/1000
			#Current is in mA. Convert.
            I = float(I)/1000
			#Panel Voltage conversion
            VPV = float(VPV)/1000
			#Load Current conversion
            IL = float(IL)/1000
			
			#Calculate the Current from Solar since charging controller only reports wattage
            IPho = float(PPV)/float(VPV)
			#calculate load wattage
            WL = float(V)*float(IL)
			#calculate Battery wattage
            BL = float(V)*float(I)
			
			#build insertstring
            query = "INSERT INTO stats (Timestamp, VBat, IBat, WBat, VPho, IPho, WPho, IL, WL, CS) VALUES (UNIX_TIMESTAMP(NOW()), '"+str(V)+"', '"+str(I)+"', '"+str(BL)+"', '"+str(VPV)+"', '"+str(IPho)+"', '"+str(PPV)+"', '"+str(IL)+"', '"+str(WL)+"', '"+str(CS)+"')"
            #write to db
            sqlConnect.Execute(query)



if __name__=="__main__":
    print "run..."
    run()
    print "done..."
