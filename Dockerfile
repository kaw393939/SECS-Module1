#Depending on the operating system of the host machines(s) that will build or run the containers, the image specified in the FROM statement may need to be changed.
#For more information, please see https://aka.ms/containercompat

FROM mcr.microsoft.com/dotnet/core/runtime:3.0-nanoserver-1903 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/core/sdk:3.0-nanoserver-1903 AS build
WORKDIR /src
COPY ["Module1.csproj", ""]
RUN dotnet restore "./Module1.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "Module1.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Module1.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Module1.dll"]