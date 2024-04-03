import type {APIGatewayProxyEvent, APIGatewayProxyResult} from "aws-lambda";

export const handler = async (
    event: APIGatewayProxyEvent
): Promise<APIGatewayProxyResult> => {
    const ipAddress = event.requestContext.identity.sourceIp;

    return {
        statusCode: 200,
        body: JSON.stringify({
            message: 'Hello World!',
            your_ip: ipAddress,
        }),
    }
}