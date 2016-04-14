clear all
close all
clc

test2 = imread('test.png');

contour = contourTracing_MooreNeighborhoodMethod(test2);
endpoints = findEndpoints(contour)
findLineLength(endpoints)

descriptors = struct('e', endpoints);
determineShape(descriptors)