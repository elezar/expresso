# Expresso

Expresso is a Python-based GUI for designing, training and exploring deep-learning frameworks. It is built atop [Caffe](http://caffe.berkeleyvision.org), the open-source, prize-winning software popularly used to develop Convolutional Neural Networks.

Please visit the [project page](http://val.serc.iisc.ernet.in/expresso) for an overview of Expresso's features, installation instructions and tutorials to help you get started.

# Docker deployment
The supplied docker image allows for Expresso to be built. This assumes the
"expresso" docker image name.

The docker image is built using:

docker build -t expresso .

And then run using:

bash ./run_docker.sh

