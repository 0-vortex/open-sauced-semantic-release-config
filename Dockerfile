FROM node:18-alpine

RUN apk add --update --no-cache git git-lfs jq openssh

COPY package.json /

RUN npm i -g npm@latest
RUN npm i -g $( jq -j '.dependencies|to_entries|map("\(.key)@\(.value) ")|.[]' /package.json )

COPY release.config.js /usr/local/lib/release.config.js

RUN apk add --update make \
  && rm -rf /var/cache/apk/* \
  && rm -rf /package.json

git config --global --add safe.directory $GITHUB_WORKSPACE

ENTRYPOINT ["npx"]

CMD ["semantic-release", "--extends", "/usr/local/lib/release.config.js"]
