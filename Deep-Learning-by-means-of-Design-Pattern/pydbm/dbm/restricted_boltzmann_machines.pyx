# -*- coding: utf-8 -*-
import numpy as np
cimport numpy as np
from pydbm.synapse_list import Synapse
from pydbm.approximation.interface.approximate_interface import ApproximateInterface


class RestrictedBoltzmannMachine(object):
    '''
    Restricted Boltzmann Machine.
    '''
    # Complete bipartite graph.
    __graph = None
    # Learning rate.
    __learning_rate = 0.5
    # The object of function approximation.
    __approximate_interface = None

    def get_graph(self):
        ''' getter of graph '''
        return self.__graph

    def set_read_only(self, value):
        ''' setter of graph '''
        raise TypeError("Read Only.")

    graph = property(get_graph, set_read_only)

    def __init__(
        self,
        graph,
        double learning_rate=0.005,
        double dropout_rate=0.5,
        approximate_interface=None
    ):
        '''
        Initialize.

        Args:
            graph:                  Synapse.
            learning_rate:          Learning rate.
            dropout_rate:           Dropout rate.
            approximate_interface:  The object of function approximation.

        '''
        if isinstance(graph, Synapse) is False:
            raise TypeError("Synapse")

        if isinstance(approximate_interface, ApproximateInterface) is False:
            if approximate_interface is not None:
                raise TypeError("ApproximateInterface")

        self.__graph = graph
        self.__learning_rate = learning_rate
        self.__dropout_rate = dropout_rate
        self.__approximate_interface = approximate_interface

    def approximate_learning(
        self,
        np.ndarray observed_data_arr,
        int traning_count, 
        int batch_size
    ):
        '''
        Learning with function approximation.

        Args:
            observed_data_arr:      The array of observed data points.
            traning_count:          Training counts.
            batch_size:             Batch size.
        '''
        self.__graph = self.__approximate_interface.approximate_learn(
            self.__graph,
            self.__learning_rate,
            self.__dropout_rate,
            observed_data_arr,
            traning_count=traning_count,
            batch_size=batch_size
        )

    def approximate_inferencing(
        self,
        np.ndarray observed_data_arr,
        int traning_count,
        int r_batch_size
    ):
        '''
        Learning with function approximation.

        Args:
            observed_data_arr:    The array of observed data points.
            traning_count:        Training counts.
            r_batch_size:         Batch size.
                                  If this value is `0`, the inferencing is a recursive learning.
                                  If this value is more than `0`, the inferencing is a mini-batch recursive learning.
                                  If this value is '-1', the inferencing is not a recursive learning.

        '''
        self.__graph = self.__approximate_interface.approximate_inference(
            self.__graph,
            self.__learning_rate,
            self.__dropout_rate,
            observed_data_arr,
            traning_count=traning_count,
            r_batch_size=r_batch_size
        )

    def get_reconstruct_error_list(self):
        '''
        Extract reconstruction error.

        Returns:
            The list.
        '''
        return self.__approximate_interface.reconstruct_error_list
