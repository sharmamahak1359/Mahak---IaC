FROM mcr.microsoft.com/dotnet/core:7.0 AS build-env
WORKDIR /app


COPY *.csproj ./
RUN dotnet restore


COPY . ./
RUN dotnet publish -c Release -o out


FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app
EXPOSE 80
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "weatherapi.dll"]