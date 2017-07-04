import sys,caffe
import numpy as np

meanfile='G:/mean.binaryproto'

blob=caffe.proto.caffe_pb2.BlobProto()
mean=open(meanfile,'rb').read()
blob.ParseFromString(mean)
arr=np.array(caffe.io.blobproto_to_array(blob))

print np.mean(arr[0][0])
print np.mean(arr[0][1])
print np.mean(arr[0][2])