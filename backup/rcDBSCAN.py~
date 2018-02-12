# DBSCAN 4 PyCOMPSs
# This version is an attempt to divide merge_task_ps_0 in smaller tasks.
# The reason why it has been captured in a different script is that previous 
# version is sufficiently good to consider not ruining it, as done in previous
# cases.
# carlos.segarra @ bsc.es

# Imports
from pycompss.api.task import task
# from pycompss.api.parameter import INOUT
from pycompss.api.api import compss_wait_on
from pycompss.api.api import compss_delete_object
from collections import defaultdict
from classes.DS import DisjointSet
from classes.Data import Data
from ast import literal_eval
import copy
import itertools
import time
import numpy as np
import sys
import os


def count_lines(tupla, file_id):
    # path = "/gpfs/projects/bsc19/COMPSs_DATASETS/dbscan/"+str(file_id)
    path = "~/DBSCAN/data/"+str(file_id)
    path = os.path.expanduser(path)
    tmp_string = path+"/"+str(tupla[0])
    for num, j in enumerate(tupla):
        if num > 0:
            tmp_string += "_"+str(j)
    tmp_string += ".txt"
    with open(tmp_string) as infile:
        for i, line in enumerate(infile):
            pass
        return i+1


def orquestrate_init_data(tupla, file_id, len_data, quocient,
                          res, fut_list, TH_1):
    THRESHOLD = TH_1
    if (len_data/quocient) > THRESHOLD:
        fut_list = orquestrate_init_data(tupla, file_id, len_data,
                                         quocient*2, res*2 + 0, fut_list,
                                         THRESHOLD)
        fut_list = orquestrate_init_data(tupla, file_id, len_data,
                                         quocient*2, res*2 + 1, fut_list,
                                         THRESHOLD)
    else:
        tmp_f = init_data(tupla, file_id, quocient, res)
        fut_list.append(tmp_f)
    return fut_list


@task(returns=1)
def init_data(tupla, file_id, quocient, res):
    data_pos = Data()
    # path = "/gpfs/projects/bsc19/COMPSs_DATASETS/dbscan/"+str(file_id)
    path = "~/DBSCAN/data/"+str(file_id)
    path = os.path.expanduser(path)
    tmp_string = path+"/"+str(tupla[0])
    for num, j in enumerate(tupla):
        if num > 0:
            tmp_string += "_"+str(j)
    tmp_string += ".txt"
    from pandas import read_csv
    df = read_csv(tmp_string, sep=' ', skiprows=lambda x: (x % quocient)
                  != res)
    data_pos.value = df.values.astype(float)
    if np.shape(data_pos.value)[0] == 0:
        data_pos.value = np.array([df.columns.values.astype(float)])
    tmp_vec = -2*np.ones(np.shape(data_pos.value)[0])
    data_pos.value = [data_pos.value, tmp_vec]
    return data_pos


@task(returns=1)
def merge_task_init(*args):
    tmp_data = Data()
    tmp_data.value = [np.vstack([i.value[0] for i in args]),
                      np.concatenate([i.value[1] for i in args])]
    return tmp_data


def neigh_squares_query(square, epsilon, dimensions):
    # Only multiples of 10 are supported as possible number
    # of squares per side.
    dim = len(square)
    neigh_squares = []
    border_squares = [int(min(max(epsilon*i, 1), i-1)) for i in dimensions]
#    border_squares = int(max(epsilon/0.1, 1))
    perm = []
    for i in range(dim):
        perm.append(range(-border_squares[i], border_squares[i] + 1))
    for comb in itertools.product(*perm):
        current = []
        for i in range(dim):
            if square[i] + comb[i] in range(dimensions[i]):
                current.append(square[i]+comb[i])
        if len(current) == dim and current != list(square):
            neigh_squares.append(tuple(current))
    neigh_squares.append(tuple(square))
    return tuple(neigh_squares)


def orquestrate_scan_merge(data, epsilon, min_points, len_neighs, quocient,
                           res, fut_list, TH_1, *args):
    # TODO: currently hardcoded
    THRESHOLD = TH_1
    if (len_neighs/quocient) > THRESHOLD:
        fut_list[0], fut_list[1] = orquestrate_scan_merge(data, epsilon,
                                                          min_points,
                                                          len_neighs,
                                                          quocient*2,
                                                          res*2 + 0,
                                                          fut_list, THRESHOLD,
                                                          *args)
        fut_list[0], fut_list[1] = orquestrate_scan_merge(data, epsilon,
                                                          min_points,
                                                          len_neighs,
                                                          quocient*2,
                                                          res*2 + 1,
                                                          fut_list, THRESHOLD,
                                                          *args)
    else:
        obj = [[], []]
        obj[0], obj[1] = partial_scan_merge(data, epsilon, min_points,
                                            quocient, res, *args)
        for num, _list in enumerate(fut_list):
            _list.append(obj[num])
    return fut_list[0], fut_list[1]


@task(returns=2)
def partial_scan_merge(data, epsilon, min_points, quocient, res, *args):
    # Core point location in the data chunk
    data_copy = Data()
    data_copy.value = [np.array([i for num, i in enumerate(data.value[0])
                                 if ((num % quocient) == res)]),
                       np.array([i for num, i in enumerate(data.value[1])
                                 if ((num % quocient) == res)])]
    neigh_points = np.vstack([i.value[0] for i in args])
    neigh_points_clust = np.concatenate([i.value[1] for i in args])
    non_assigned = defaultdict(int)
    for num, point in enumerate(data_copy.value[0]):
        poss_neigh = np.linalg.norm(neigh_points-point, axis=1) - epsilon < 0
        neigh_count = np.sum(poss_neigh)
        if neigh_count > min_points:
            data_copy.value[1][num] = -1
        elif neigh_count > 0:
            tmp = []
            for pos, proxim in enumerate(poss_neigh):
                if proxim:
                    # Adding three since later to detect core points we will
                    # require value > -1 and -0 is > 1 and not to confuse it
                    # with a noise point
                    if neigh_points_clust[pos] == -1:
                        data_copy.value[1][num] = -(pos+3)
                        break
                    else:
                        tmp.append(pos)
            else:
                non_assigned[num] = tmp

    # Local clustering
    cluster_count = 0
    core_points_tmp = [p for num, p in enumerate(data_copy.value[0])
                                 if data_copy.value[1][num] == -1]
    if len(core_points_tmp) != 0:
        core_points_tmp = np.vstack(core_points_tmp)
        core_points = [[num, p] for num, p in enumerate(core_points_tmp)]
        for pos, point in core_points:
            tmp_vec = ((np.linalg.norm(core_points_tmp - point, axis=1)-epsilon)
                       < 0)
            for num, poss_neigh in enumerate(tmp_vec):
                if poss_neigh and data_copy.value[1][num] > -1:
                    data_copy.value[1][pos] = data_copy.value[1][num]
                    break
            else:
                data_copy.value[1][pos] = cluster_count
                cluster_count += 1
    return data_copy, non_assigned


@task(returns=3)
def merge_task_ps_0(*args):
    num_clust_max = max([i for i in args[0].value[1]])+1
    data = args[0]
    for i in range(len(args)-1):
        data.value = [np.vstack([data.value[0], args[i+1].value[0]]),
                      np.concatenate([data.value[1], [j + num_clust_max if
                                                      j > -1 else j for j in
                                                      args[i+1].value[1]]])]
        num_clust_max += max(max([j for j in args[i+1].value[1]])+1, 0)
    return data, [int(num_clust_max)], [int(num_clust_max)]


@task(returns=defaultdict)
def merge_task_ps_1(*args):
    # This one is for data type
    border_points = defaultdict(list)
    for _dict in args:
        for key in _dict:
            border_points[key] += _dict[key]
    return border_points


def dict_compss_wait_on(dicc, dimension_perms):
    for comb in itertools.product(*dimension_perms):
        dicc[comb] = compss_wait_on(dicc[comb])
    return dicc


def orquestrate_sync_clusters(data, adj_mat, epsilon, coord, neigh_sq_loc,
                              len_neighs, quocient, res, fut_list, TH_2, *args):
    # TODO: currently hardcoded
    THRESHOLD = TH_2
    if (len_neighs/quocient) > THRESHOLD:
        fut_list = orquestrate_sync_clusters(data, adj_mat, epsilon, coord,
                                             neigh_sq_loc, len_neighs,
                                             quocient*2, res*2 + 0, fut_list,
                                             THRESHOLD, *args)
        fut_list = orquestrate_sync_clusters(data, adj_mat, epsilon, coord,
                                             neigh_sq_loc, len_neighs,
                                             quocient*2, res*2 + 1, fut_list,
                                             THRESHOLD, *args)
    else:
        fut_list.append(sync_clusters(data, adj_mat, epsilon, coord,
                                      neigh_sq_loc, quocient, res, len_neighs,
                                      *args))
    return fut_list


@task(returns=list)
def merge_task(adj_mat, *args):
    adj_mat_copy = [[] for _ in range(max(adj_mat[0], 1))]
    for args_i in args:
        for num, list_elem in enumerate(args_i):
            for elem in list_elem:
                if elem not in adj_mat_copy[num]:
                    adj_mat_copy[num].append(elem)
    print adj_mat_copy
    return adj_mat_copy


@task(returns=list)
def sync_clusters(data, adj_mat, epsilon, coord, neigh_sq_loc, quocient,
                  res, len_neighs, *args):
    # TODO: change *args
    adj_mat_copy = [[] for _ in range(max(adj_mat[0], 1))]
    neigh_data = [np.vstack([i.value[0] for i in args]),
                  np.concatenate([i.value[1] for i in args])]
    neigh_data = [np.vstack([i for num, i in
                             enumerate(neigh_data[0])
                             if ((num % quocient) == res)]),
                  np.array([i for num, i in enumerate(neigh_data[1])
                            if ((num % quocient) == res)])]
    tmp_unwrap = [neigh_sq_loc[i] for i in range(len(neigh_sq_loc))
                  for j in range(len(args[i].value[1]))]
    tmp_unwrap = [i for num, i in enumerate(tmp_unwrap) if
                  ((num % quocient) == res)]
    for num1, point1 in enumerate(data.value[0]):
        current_clust_id = int(data.value[1][num1])
        if current_clust_id > -1:
            tmp_vec = (np.linalg.norm(neigh_data[0]-point1, axis=1) -
                       epsilon) < 0
            for num2, poss_neigh in enumerate(tmp_vec):
                loc2 = tmp_unwrap[num2]
                if poss_neigh:
                    clust_ind = int(neigh_data[1][num2])
                    adj_mat_elem = [loc2, clust_ind]
                    if ((clust_ind > -1) and
                        (adj_mat_elem not in
                            adj_mat_copy[current_clust_id])):
                        adj_mat_copy[current_clust_id].append(adj_mat_elem)
    return adj_mat_copy


def unwrap_adj_mat(tmp_mat, adj_mat, neigh_sq_coord, dimension_perms):
    links_list = []
    for comb in itertools.product(*dimension_perms):
        for k in range(tmp_mat[comb][0]):
            links_list.append([comb, k])
    mf_set = DisjointSet(links_list)
    for comb in itertools.product(*dimension_perms):
            # For an implementation issue, elements in adj_mat are
            # wrapped with an extra pair of [], hence the j[0]
        for k in range(len(adj_mat[comb][0])-1):
            mf_set.union(adj_mat[comb][0][k], adj_mat[comb][0][k+1])
    out = mf_set.get()
    return out


@task()
def expand_cluster(data, epsilon, border_points, dimension_perms, links_list,
                   square, cardinal, file_id, *args):
    data_copy = Data()
    data_copy.value = copy.deepcopy(data.value)
    tmp_unwrap_2 = [i.value[1] for i in args]
    neigh_points_clust = np.concatenate(tmp_unwrap_2)
    for elem in border_points:
        for p in border_points[elem]:
            if neigh_points_clust[p] > -1:
                data_copy.value[1][elem] = neigh_points_clust[p]
                break
    for num, elem in enumerate(data_copy.value[1]):
        if elem < -2:
            clust_ind = -1*elem - 3
            data_copy.value[1][num] = neigh_points_clust[clust_ind]

    # Map all cluster labels to general numbering
    mappings = []
    for k, links in enumerate(links_list):
        for pair in links:
            if pair[0] == square:
                mappings.append([pair[1], k])
    for num, elem in enumerate(data_copy.value[1]):
        if elem > -1:
            for pair in mappings:
                if int(elem) == pair[0]:
                    data_copy.value[1][num] = pair[1]

    # Update all files (for the moment writing to another one)
    # path = "/gpfs/projects/bsc19/COMPSs_DATASETS/dbscan/"+str(file_id)
    path = "~/DBSCAN/data/"+str(file_id)
    path = os.path.expanduser(path)
    tmp_string = path+"/"+str(square[0])
    for num, j in enumerate(square):
        if num > 0:
            tmp_string += "_"+str(j)
    tmp_string += "_OUT.txt"
    f_out = open(tmp_string, "w")
    for num, val in enumerate(data_copy.value[0]):
        f_out.write(str(data_copy.value[0][num])+" "
                    + str(int(data_copy.value[1][num])) + "\n")
    f_out.close()


def DBSCAN(epsilon, min_points, file_id, TH_1, TH_2):
    #   TODO: code from scratch the Disjoint Set
    #   TODO: comment the code apropriately
    #   TODO: separate the code in different modules

    # DBSCAN Algorithm
    initial_time = time.time()

    # Initial Definitions (necessary?)
    epsilon = float(epsilon)
    min_points = int(min_points)
    dataset_info = "dataset.txt"

    # Data inisialitation
    dimensions = []
    f = open(dataset_info, "r")
    for line in f:
        split_line = line.split()
        if split_line[0] == file_id:
            dimensions = literal_eval(split_line[1])
            break
    dimension_perms = [range(i) for i in dimensions]
    dataset = defaultdict()
    dataset_tmp = defaultdict()
    neigh_sq_coord = defaultdict()
    len_datasets = defaultdict()
    adj_mat = defaultdict()
    tmp_mat = defaultdict()
    border_points = defaultdict()
    for comb in itertools.product(*dimension_perms):
        # TODO: implement init_data as a class method maybe inside
        # the initialisation
        dataset[comb] = Data()
        dataset_tmp[comb] = Data()
        len_datasets[comb] = count_lines(comb, file_id)
        adj_mat[comb] = [0]
        tmp_mat[comb] = [0]
        border_points[comb] = defaultdict(list)
        fut_list = orquestrate_init_data(comb, file_id, len_datasets[comb], 1,
                                         0, [], TH_1)
        dataset_tmp[comb] = merge_task_init(*fut_list)
        neigh_sq_coord[comb] = neigh_squares_query(comb, epsilon,
                                                   dimensions)

    # Partial Scan And Initial Cluster merging
#    dataset_tmp = dict_compss_wait_on(dataset_tmp, dimension_perms)
    for comb in itertools.product(*dimension_perms):
        adj_mat[comb] = [0]
        tmp_mat[comb] = [0]
        neigh_squares = []
        for coord in neigh_sq_coord[comb]:
            neigh_squares.append(dataset_tmp[coord])
        fut_list_0, fut_list_1 = orquestrate_scan_merge(dataset_tmp[comb],
                                                        epsilon, min_points,
                                                        len_datasets[coord],
                                                        1, 0, [[], []], TH_1,
                                                        *neigh_squares)
        # De moment podria no pasarli el cluster count de cada un i buscarlo
        dataset[comb], tmp_mat[comb], adj_mat[comb] = merge_task_ps_0(*fut_list_0)
        border_points[comb] = merge_task_ps_1(*fut_list_1)

    # Cluster Synchronisation
    for comb in itertools.product(*dimension_perms):
        compss_delete_object(dataset_tmp[comb])
        neigh_squares = []
        neigh_squares_loc = []
        len_neighs = 0
        for coord in neigh_sq_coord[comb]:
            neigh_squares_loc.append(coord)
            neigh_squares.append(dataset[coord])
            len_neighs += len_datasets[coord]
        # TODO: make as INOUT instead of OUT, currently not working
        fut_list = orquestrate_sync_clusters(dataset[comb], adj_mat[comb],
                                             epsilon, comb, neigh_squares_loc,
                                             len_neighs, 1, 0, [], TH_2,
                                             *neigh_squares)
        adj_mat[comb] = merge_task(adj_mat[comb], *fut_list)

    # Cluster list update
    # TODO: join the three
    border_points = dict_compss_wait_on(border_points, dimension_perms)
    tmp_mat = dict_compss_wait_on(tmp_mat, dimension_perms)
    adj_mat = dict_compss_wait_on(adj_mat, dimension_perms)
    links_list = unwrap_adj_mat(tmp_mat, adj_mat, neigh_sq_coord,
                                dimension_perms)
    for comb in itertools.product(*dimension_perms):
        neigh_squares = []
        for coord in neigh_sq_coord[comb]:
            neigh_squares.append(dataset[coord])
        expand_cluster(dataset[comb], epsilon, border_points[comb],
                       dimension_perms, links_list, comb, tmp_mat[comb],
                       file_id, *neigh_squares)
    print links_list
    print "Time elapsed: " + str(time.time()-initial_time)
    return 1


if __name__ == "__main__":
    DBSCAN(float(sys.argv[1]), int(sys.argv[2]), sys.argv[3], int(sys.argv[4]),
            int(sys.argv[5]))
