FROM debian:stretch

LABEL "com.github.actions.name"="lint"
LABEL "com.github.actions.description"="Lint Verilog code using Verilator"

LABEL "repository"="http://github.com/TalBrenev/doom58"
LABEL "maintainer"="Tal Brenev <tal.brenev@gmail.com>"

RUN apt update && apt install -y perl verilator
