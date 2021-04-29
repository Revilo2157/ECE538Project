import sys
import random

def merge(toDo):
    ret = []
    toAdd = []
    quote = False
    for item in toDo:
        if isinstance(item, str) and not (item == " " and not quote):
            if item == '"':
                quote = not quote

            toAdd.append(item)
        else:
            if toAdd:
                ret.append("".join(toAdd))
                toAdd = []
            else:
                if not item == " ": 
                    ret.append(item) 
    if toAdd:
        ret.append("".join(toAdd))
    return ret

def doRandom():
    return chance > random.uniform(0, 100)

def increaseDelay(dString):
    vals = dString.split(":")
    inc = random.uniform(0.001, MAX)
    return ":".join([str(inc + float(val))[:5] for val in vals])


def toString(object, file):
    if isinstance(object, list):
        file.write("\n(")
        for item in object:
            toString(item, file)
            file.write(" ")
        file.write(")")
    else:
        file.write(object)

def getCurrentScope(level):
    item = stack
    for scope in range(level - 1):
        item = item[-1]
    return item

def meetsCriteria(cell):
    return "NAND" in cell or "AND" in cell or "INV" in cell

stack = []
currLevel = 0

if not len(sys.argv) == 4:
    print("Not enough arguments \ntopLevel, MAX Delay ex: (0.005), chance for fault ex: (0.01)")
    exit()

file = "compilation/%s.sdf" % sys.argv[1]
MAX = float(sys.argv[2])
chance = float(sys.argv[3])
num_faults = 0
num_nets = 0

with open(file, "r") as sdfFile:
    inner = []
    while True:
        line = sdfFile.readline()
        
        if not line:
            break

        
        for char in line:
            if char == "\n":
                continue

            if char == "(":
                currScope = getCurrentScope(currLevel)

                if not currLevel:
                    currLevel += 1
                    continue

                toAdd = merge(inner)
                if toAdd:
                    getCurrentScope(currLevel).extend(toAdd)
                 
                inner = []
                getCurrentScope(currLevel).append([])
                currLevel += 1


            elif char == ")":
                item = getCurrentScope(currLevel)
                
                toAdd = merge(inner)
                if toAdd:
                    item.extend(toAdd)
                inner = []
                
                currLevel -= 1

                if currLevel == 1:
                    net = stack[-1]
                    cell = net[1]
                    if isinstance(cell, list):
                        num_nets += 1 
                        if meetsCriteria(cell[1]):
                            # print(cell[1])
                            for instance in net[3][1][1:]:
                                for delay in instance:
                                    if isinstance(delay, list):
                                        if doRandom():
                                            # print(delay ,end= " -> ")
                                            dString = delay.pop()
                                            delay.append(increaseDelay(dString))
                                            num_faults += 1
                                            # print(delay)
            else:
                inner.append(char)

print(num_nets, num_faults, int(num_faults / num_nets * 10000) / 100, sys.argv[1:])
        
with open("compilation/%s_faulty.sdf" % sys.argv[1], "w") as toWrite:
    toString(stack, toWrite)