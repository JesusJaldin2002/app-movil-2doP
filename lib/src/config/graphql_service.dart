import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:segundo_parcial_movil/src/config/environment/environment.dart';

class GraphQLService {
  late final GraphQLClient client;

  GraphQLService() {
    final HttpLink httpLink = HttpLink(Environment.apiUrl);

    client = GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: InMemoryStore()),
    );
  }

  Future<QueryResult> performQuery(
    String query, {
    Map<String, dynamic>? variables,
    Map<String, String>? headers, // Agregar headers opcionales
  }) async {
    final options = QueryOptions(
      document: gql(query),
      variables: variables ?? {},
      context: headers != null
          ? const Context().withEntry(HttpLinkHeaders(headers: headers))
          : const Context(),
    );
    return await client.query(options);
  }

  Future<QueryResult> performMutation(
    String mutation, {
    Map<String, dynamic>? variables,
    Map<String, String>? headers, // Agregar headers opcionales
  }) async {
    final options = MutationOptions(
      document: gql(mutation),
      variables: variables ?? {},
      context: headers != null
          ? const Context().withEntry(HttpLinkHeaders(headers: headers))
          : const Context(),
    );
    return await client.mutate(options);
  }
}
