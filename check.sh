#!/bin/bash

# Pasta e URL do repositório do GitHub
pasta_downloads="${HOME}/Downloads"
repo="pineappleEA/pineapple-src"
release_endpoint="https://api.github.com/repos/${repo}/releases/latest"

# Obter o nome do arquivo .AppImage mais recente no GitHub
release_info=$(curl -s "${release_endpoint}")
download_url=$(echo "${release_info}" | grep "browser_download_url" | grep -oE 'https://[^"]+\.AppImage')
filename=$(basename "${download_url}")

# Obter o nome do arquivo .AppImage mais recente na pasta de downloads
arquivo_downloads=$(find "${pasta_downloads}" -maxdepth 1 -name "*.AppImage" -printf "%f\n" 2>/dev/null | sort -V | tail -n 1)

# Verificar se existe um arquivo .AppImage na pasta de downloads
if [[ -z "${arquivo_downloads}" ]]; then
  echo "Nenhum arquivo .AppImage encontrado na pasta ${pasta_downloads}."
else
  # Comparar os nomes dos arquivos
  if [[ "${filename}" > "${arquivo_downloads}" ]]; then
    # Baixar o arquivo .AppImage mais recente
    echo "Baixando o arquivo .AppImage mais recente..."
    wget -q --show-progress -P "${pasta_downloads}" "${download_url}"
    echo "Download concluído!"
  else
    echo "Arquivo mais recente já baixado."
  fi
fi
