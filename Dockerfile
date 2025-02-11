FROM ghcr.io/tinfoilsh/nitro-attestation-shim:v0.1.4 AS shim

FROM ollama/ollama

RUN apt update -y
RUN apt install -y iproute2

COPY --from=shim /nitro-attestation-shim /nitro-attestation-shim

ENV HOME=/

RUN nohup bash -c "ollama serve &" && sleep 5 && ollama pull llama3.2:1b

ENTRYPOINT ["/nitro-attestation-shim", "-d", "inference-enclave.tinfoil.sh", "-e", "nate@tinfoil.sh", "-p", "/api/chat", "-u", "11434", "-c", "7443", "-l", "443", "--", "/bin/ollama", "serve"]
