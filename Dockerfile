#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["RemoteDebug.csproj", "."]
RUN dotnet restore "./RemoteDebug.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "RemoteDebug.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "RemoteDebug.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "RemoteDebug.dll"]