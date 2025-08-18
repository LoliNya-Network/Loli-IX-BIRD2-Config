#!/bin/bash

update_prefix () {
  echo "[INFO] 正在更新 loliix ($1)"

  echo "[INFO] 获取前缀列表 prefix_loliix"
  bgpq4 -S RPKI,RIPE,APNIC,ARIN,AFRINIC,LACNIC -6 -b -R 48 -l prefix_loliix "$1" > "loliix.conf.prefix" 2> "loliix.prefix.err"
  
  if [ ! -s "loliix.conf.prefix" ]; then
    echo "[ERROR] loliix ($1) 前缀获取失败，内容为空"
    cat "loliix.prefix.err"
    return 1
  fi

  echo "[INFO] 获取ASN列表 asn_loliix"
  bgpq4 -S RPKI,RIPE,APNIC,ARIN,AFRINIC,LACNIC -tb -l asn_loliix "$1" > "loliix.conf.asns" 2> "loliix.asns.err"

  if [ ! -s "loliix.conf.asns" ]; then
    echo "[ERROR] loliix ($1) ASN 获取失败，内容为空"
    cat "loliix.asns.err"
    return 1
  fi

  echo "[INFO] 合并生成配置 loliix.conf"
  {
    echo -n "define "
    cat "loliix.conf.prefix"
    echo ""
    echo -n "define "
    cat "loliix.conf.asns"
  } > "loliix.conf"

  echo "[INFO] 清理临时文件"
  rm -f "loliix.conf.prefix" "loliix.conf.asns" "loliix.prefix.err" "loliix.asns.err"

  echo "[OK] loliix ($1) 配置生成完成: loliix.conf"
}

update_prefix as207529:as-loli-ix