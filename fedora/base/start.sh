#!/bin/bash

systemctl enable sshd
systemctl start sshd

systemctl enable mongod

/bin/bash