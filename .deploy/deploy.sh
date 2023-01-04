# 校验 Jar 包是否存在
if ! test -f "target/${PACKAGE_NAME}.jar"; then
    echo "${PACKAGE_NAME}.jar 不存在"
    exit 43
fi

echo "复制 Jar 包到 Docker 文件夹"
cp "target/${PACKAGE_NAME}.jar" "docker/${PACKAGE_NAME}.jar"

# 构建镜像
echo "开始构建镜像"
docker build -t "${IMAGE_NAME}:${IMAGE_VERSION}" --build-arg PACKAGE_NAME="${PACKAGE_NAME}" docker

# run container
# 删除旧容器
containerId=$(docker ps -f name="${APP_NAME}-${APP_VERSION}" -aq)
if [ "${containerId}" != "" ]; then
    echo "删除旧容器 ${containerId}"
    docker rm -f "${containerId}"
fi

# 运行新容器
echo "运行新容器, ContainerName: ${APP_NAME}-${APP_VERSION}"
docker run --restart=always -dp "${SERVER_PORT}:${SERVER_PORT}" --name "${APP_NAME}-${APP_VERSION}" "${IMAGE_NAME}:${IMAGE_VERSION}" --server.port="${SERVER_PORT}"

# 判断容器运行情况，未运行则抛出异常
echo "容器运行情况:"
docker ps -f name="${APP_NAME}-${APP_VERSION}"
containerId=$(docker ps -f name="${APP_NAME}-${APP_VERSION}" -q)

if [ "${containerId}" = "" ]; then
    echo "容器未运行"
    exit 42
fi