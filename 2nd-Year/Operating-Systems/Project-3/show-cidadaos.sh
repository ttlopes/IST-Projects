#!/bin/bash

# -------------------------------------
# Author: Tomás de Sousa Tunes Lopes
# Course: Operating Systems - Project 3
# -------------------------------------

hexdump -e '"| %6i | %-20.100s | %2i | %-23.100s | %-9.12s | %i | %i |\n"' cidadaos.dat