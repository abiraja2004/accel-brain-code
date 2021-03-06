# -*- coding: utf-8 -*-
import numpy as np
cimport numpy as np
cimport cython
import random
ctypedef np.float64_t DOUBLE_t
from pydbm.activation.interface.activating_function_interface import ActivatingFunctionInterface


class Synapse(object):
    '''
    The object of synapse.
    '''
    # The weights of links
    __weights_arr = np.array([])

    def get_weights_arr(self):
        ''' getter '''
        if isinstance(self.__weights_arr, np.ndarray) is False:
            raise TypeError("The type of __weights_arr must be `np.ndarray`.")
        return self.__weights_arr

    def set_weights_arr(self, value):
        ''' setter '''
        if isinstance(value, np.ndarray) is False:
            raise TypeError("The type of __weights_arr must be `np.ndarray`.")
        self.__weights_arr = value

    weights_arr = property(get_weights_arr, set_weights_arr)

    # The diff of weights.
    __diff_weights_arr = np.array([])

    def get_diff_weights_arr(self):
        ''' getter '''
        if isinstance(self.__diff_weights_arr, np.ndarray) is False:
            raise TypeError("The type of __diff_weights_arr must be `np.ndarray`.")
        return self.__diff_weights_arr

    def set_diff_weights_arr(self, value):
        ''' setter '''
        if isinstance(value, np.ndarray) is False:
            raise TypeError("The type of __diff_weights_arr must be `np.ndarray`.")
        self.__diff_weights_arr = value

    diff_weights_arr = property(get_diff_weights_arr, set_diff_weights_arr)

    # Activation function in shallower layer.
    __shallower_activating_function = None

    def get_shallower_activating_function(self):
        ''' getter '''
        if isinstance(self.__shallower_activating_function, ActivatingFunctionInterface) is False:
            raise TypeError("The type of __shallower_activating_function must be `ActivatingFunctionInterface`.")
        return self.__shallower_activating_function

    def set_shallower_activating_function(self, value):
        ''' setter '''
        if isinstance(value, ActivatingFunctionInterface) is False:
            raise TypeError("The type of __shallower_activating_function must be `ActivatingFunctionInterface`.")

        self.__shallower_activating_function = value

    shallower_activating_function = property(get_shallower_activating_function, set_shallower_activating_function)

    # Activation function in deeper layer.
    __deeper_activating_function = None

    def get_deeper_activating_function(self):
        ''' getter '''
        if isinstance(self.__deeper_activating_function, ActivatingFunctionInterface) is False:
            raise TypeError("The type of __deeper_activating_function must be `ActivatingFunctionInterface`.")
        return self.__deeper_activating_function

    def set_deeper_activating_function(self, value):
        ''' setter '''
        if isinstance(value, ActivatingFunctionInterface) is False:
            raise TypeError("The type of __deeper_activating_function must be `ActivatingFunctionInterface`.")
        self.__deeper_activating_function = value

    deeper_activating_function = property(get_deeper_activating_function, set_deeper_activating_function)

    def create_node(
        self,
        int shallower_neuron_count,
        int deeper_neuron_count,
        shallower_activating_function,
        deeper_activating_function,
        np.ndarray weights_arr=np.array([])
    ):
        '''
        Set links of nodes to the graphs.

        Args:
            shallower_neuron_count:             The number of neurons in shallower layer.
            deeper_neuron_count:                The number of neurons in deeper layer.
            shallower_activating_function:      The activation function in shallower layer.
            deeper_activating_function:         The activation function in deeper layer.
            weights_arr:                        The weights of links.
        '''
        self.shallower_activating_function = shallower_activating_function
        self.deeper_activating_function = deeper_activating_function

        cdef np.ndarray init_weights_arr = np.random.uniform(size=(shallower_neuron_count, deeper_neuron_count))
        if weights_arr.shape[0]:
            self.weights_arr = weights_arr
        else:
            self.weights_arr = init_weights_arr
        self.diff_weights_arr = np.zeros(self.weights_arr.shape, dtype=float)

    def learn_weights(self):
        '''
        Update the weights of links.
        '''
        self.weights_arr = self.weights_arr + self.diff_weights_arr
        cdef int row = self.weights_arr.shape[0]
        cdef int col = self.weights_arr.shape[1]
        self.diff_weights_arr = np.zeros((row, col), dtype=float)
