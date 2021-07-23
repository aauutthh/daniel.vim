#!/bin/bash
#   vim: colorcolumn=80

###############################################################################
# filename  : <%=expand('%:t')%>
# created   : <%=strftime('%Y-%m-%d')%>
# author    : danielli
# description:
###############################################################################

# -e 错误则退出 -x 执行每步都打印
set -ex

main() {
  echo "hello"
}

main
