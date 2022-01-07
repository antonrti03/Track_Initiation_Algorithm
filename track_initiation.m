function []=track_initiation(Img, peak_num)
I=Img;
if ndims(I)==3
    I = rgb2gray(I);
end
BW = im2bw(I);
figure, imshow(Img,[]), title('Target image'), impixelinfo;
% 1. Compute the Hough transform of the binary image returned by edge.
[H,theta,rho] = hough(BW);
% 2. Find the peaks in the Hough transform matrix, H, using the houghpeaks function
P = houghpeaks(H, peak_num,'threshold',ceil(0.7*max(H(:))));
% Superimpose a plot on the image of the transform that identifies the peaks
figure,
imshow(H,[],'XData',theta,'YData',rho,'InitialMagnification','fit');
title('Finding the peaks in Hough Transform Space'), impixelinfo;
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
plot(theta(P(:,2)),rho(P(:,1)),'s','color','red');
% 3. Find lines in the image using the houghlines function
lines = houghlines(BW,theta,rho,P,'FillGap',30,'MinLength',3);
figure, imshow(Img), hold on
title('Target track initiation'), impixelinfo;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
end
% Mark target location
[R,C]=find(BW);
for k=1:length(R)
    plot(C(k),R(k),'o','Color','red');
end