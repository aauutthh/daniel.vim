---
title:  <%=expand('%:t:r')%>
date:   <%=strftime('%Y-%m-%d')%>
author: danielli
description: >-
  这里填写描述
Wiki:
  id: -1
  git: "http://gitlab.futunn.com/xxx"
  wikiupdate: >-
    pip3 install git+http://gitlab.futunn.com/danielli/oasg@v0.1
    pip3 install git+http://gitlab.futunn.com/danielli/wikiapi@v0.1
    export APPKEY=key
    export APPSEC=sec
    python -m "wikiapi.postmd" <%=expand('%:t')%>
  plugins:
    - name: imgupload
      module: wikiapi.wikiplugins.LocalImgUpload
options:
  vim: colorcolumn=80
tags:
  - tag1
---

# <%=expand('%:t:r')%>

## 修订记录

时间      |作者    |修改
-----     |-----   |-----
<%=strftime('%Y-%m-%d')%>|danielli|初稿

## 第一节

## 参考
