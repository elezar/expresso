import sys
import os
caffe_root = os.getenv('CAFFE_ROOT')
sys.path.append(caffe_root + '/python/caffe/proto')
from google.protobuf import text_format
import caffe_pb2

# TopDict is dictionary of top blobs and thier simulated sizes
# BottomDict is dictionary of bottom blobs (empty/filled)
# argDict is list of arguments requried eg{stride:3,max}


def operate(bottomDict, layerParameter):
    layerHandler = caffe_pb2.LayerParameter()
    text_format.Merge(layerParameter, layerHandler)
    conv_param = layerHandler.convolution_param

    paramdict = {}
    # First handle the optional fields:
    if(conv_param.HasField("num_output")):
        paramdict["num_output"] = conv_param.num_output
    if(conv_param.HasField("group")):
        paramdict["group"] = conv_param.group

    # The following are specified as "repeated" in caffe.proto
    # TODO: What is the best way to handle the multi-domensionality
    paramdict["stride"] = conv_param.stride[0]
    paramdict["pad"] = conv_param.pad[0]
    paramdict["size"] = conv_param.kernel_size[0]

    return getDim(bottomDict[bottomDict.keys()[0]]["dim"], **paramdict)


def getDim(old_dim, num_output=0, size=1, stride=1, pad=0, group=1):
    dim = old_dim
    dim[0] = old_dim[0]
    dim[1] = num_output / group if num_output > 0 else old_dim[1] / group
    dim[2] = (old_dim[2] - size + 2 * pad) / stride + 1
    dim[3] = (old_dim[3] - size + 2 * pad) / stride + 1
    return dim
