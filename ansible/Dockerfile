FROM williamyeh/ansible:ubuntu14.04-onbuild
ENV REQUIREMENTS requirements.txt
ENV INVENTORY inventory.ini
RUN ansible-playbook-wrapper
CMD [ "ansible-playbook-wrapper" ]
