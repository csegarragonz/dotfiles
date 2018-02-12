import os
import csv
import time
from shutil import copytree
from collections import namedtuple, defaultdict

Result = namedtuple("Result", ["nodes", "TH"])
result_table = defaultdict()

for filename in os.listdir("./outputs/"):
    if filename.endswith(".out"):
        with open("./outputs/"+filename) as f:
            num_nodes = 0
            TH_2 = False
            time = 0
            for line in f:
                if "Workers:" in line:
                    num_nodes = len(line.split())
                if "To COMPSs:" in line:
                    a = line.split()
                    if len(a) > 9:
                        TH_2 = a[10]
                    else:
                        break
                if "Time elapsed:" in line:
                    time = line.split()[2]
            else:
                name = filename.split("-")[1].split(".")[0]
                copytree("./../../../.COMPSs/" + name, "./outputs/n_nodes_" + 
                         str(num_nodes) + "_th_" + str(TH_2))
                result_table[Result(nodes = num_nodes, TH = TH_2)] = time


with open('times.csv', 'wb') as out_file:
    claus = result_table.keys()
    tmp = set([i.TH for i in sorted(claus, key = lambda x : x.TH)])
    tmp_str = ' ,'+','.join(map(str, tmp))+'\n'
    out_file.write(tmp_str)
    aux_list = [i.nodes for i in sorted(claus, key = lambda x : x.nodes)]
    nodes_sorted = list(set(aux_list))
    for i in nodes_sorted:
        aux_list = [result_table[j] for j in sorted(claus, key = lambda x:x.TH)
                    if j.nodes == i]
        tmp_str = str(i)+','+','.join(map(str, aux_list))+'\n'
        out_file.write(tmp_str)
