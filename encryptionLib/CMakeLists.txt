cmake_minimum_required(VERSION 3.10)
project(encryptionLib C)

set(CMAKE_C_STANDARD 11)

add_library(encryptionLib SHARED library.c)
