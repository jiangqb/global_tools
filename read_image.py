import os,cv2

# fout=open('F:/CelebA/align_test.txt','r')
root='F:/LFW/lfw_male/'
fin=open('F:/LFW/lfw_male.txt','w')

for parent,dirNames,fileNames in os.walk(root):
    for fileName in fileNames:
        fin.write(fileName+' '+'1\n')
        print fileName