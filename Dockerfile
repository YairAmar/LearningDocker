FROM ubuntu:20.04

#	getting bash
RUN apt-get update && apt-get install -y curl

#	Install miniconda to /miniconda
RUN curl -LO http://repo.continuum.io/miniconda/Miniconda3-py39_4.9.2-Linux-x86_64.sh
RUN bash Miniconda3-py39_4.9.2-Linux-x86_64.sh -p /miniconda -b
RUN rm Miniconda3-py39_4.9.2-Linux-x86_64.sh
ENV PATH=/miniconda/bin:${PATH}
RUN conda update -y conda

WORKDIR /miniconda/bin:${PATH}

#	installing jupyter
RUN conda install jupyter -y 

#	installing git!
RUN apt-get -y install git
	
#	for jupyter
RUN conda install -c anaconda ipykernel -y 

#	copy requirements.txt and python file into the container
COPY requirements.txt requirements.txt

#	creating an env from req-file
RUN conda create --name docker_ex_env --file requirements.txt
RUN activate docker_ex_env 
RUN python -m ipykernel install --user --name=docker_ex_env	#TO-DO - check if the name should maybe be smthing else

#	setting an entrypoint
ENTRYPOINT ["jupyter", "notebook", "--ip=*"]

EXPOSE 8888