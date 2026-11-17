# Ryot, packaged for Railway: https://github.com/aalfath/ryot-railway-template
# Upstream image pinned by version and digest. To update, change both and add a CHANGELOG entry.
FROM ghcr.io/ignisda/ryot:v10.5.8@sha256:730e67eb16c04dbdab870b06dc0c73161e23596716f53406248a9c11863b1403

# The image's Caddy proxy listens on $PORT (frontend on 3000 and backend on 5000 inside
# the container). Railway's template sets PORT=8000; 8000 is also the fallback here.
ENV PORT=8000
EXPOSE 8000

# Upstream start script: Caddy + backend (runs database migrations) + frontend.
CMD ["/usr/local/bin/run-container.sh"]
