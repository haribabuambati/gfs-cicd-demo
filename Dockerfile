FROM mcr.microsoft.com/dotnet/core/aspnet:2.2-stretch-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:2.2-stretch AS build
WORKDIR /src
COPY ["GFS_CICD_Demo/GFS_CICD_Demo.csproj", "GFS_CICD_Demo/"]
RUN dotnet restore "GFS_CICD_Demo/GFS_CICD_Demo.csproj"
COPY . .
WORKDIR "/src/GFS_CICD_Demo"
RUN dotnet build "GFS_CICD_Demo.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "GFS_CICD_Demo.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "GFS_CICD_Demo.dll"]