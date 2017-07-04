
fin = open('F:/LFW/lfw.txt','r')
fout = open('F:/LFW/lfw_gender.txt', 'w')

lines=fin.readlines()
x=[line for line in lines]
print x
x.sort()

fout.writelines(str(line) for line in x)