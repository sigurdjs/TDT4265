clear all
close all
clc

test2 = imread('test2.png');
test1 = imread('test.png');

T2 = im2bw(test2);
T1 = im2bw(test1);

T1 = padarray(T1,[1 1],1);
T2 = padarray(T2,[1 1],1);
[contour2, b2] = mooreNeighborhoodTracing(T2);
[contour1, b1] = mooreNeighborhoodTracing(T1);
% dc1 = differentiateChainCode(b1);
% dc2 = differentiateChainCode(b2);
% s1 = findShapeNumber(dc1);
% s2 = findShapeNumber(dc2);


endpoints = findEndpoints(contour1, b1);
lineLengths = findLineLength_chainCode(b1, endpoints);

descriptors = struct('e', endpoints, 'll', lineLengths);
determineShape(descriptors)

%Regionprops() calculates: area osv..   