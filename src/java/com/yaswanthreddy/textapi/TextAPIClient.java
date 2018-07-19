package com.yaswanthreddy.textapi;
import java.io.StringReader;
import java.util.*;
import javax.xml.bind.*;
import javax.xml.transform.stream.StreamSource;

public class TextAPIClient {

    private String applicationId;

    private String applicationKey;

    private boolean useHttps;

    private HttpSender httpSender;

    private String apiHostAndPath;

    private RateLimits rateLimits;

    /**
     * Constructs a Text API Client.
     *
     * @param applicationId Your application ID
     * @param applicationKey Your application key
     */
    public TextAPIClient(String applicationId, String applicationKey) {
        this(applicationId, applicationKey, true);
    }

    /**
     * Constructs a Text API Client.
     *
     * @param applicationId Your application ID
     * @param applicationKey Your application key
     * @param useHttps Whether to use HTTPS for web service calls
     */
    public TextAPIClient(String applicationId, String applicationKey, boolean useHttps) {
        if (applicationId == null || applicationId.isEmpty() ||
                applicationKey == null || applicationKey.isEmpty())
        {
            throw new IllegalArgumentException("Invalid Application ID or Application Key");
        }
        this.applicationId = applicationId;
        this.applicationKey = applicationKey;
        this.useHttps = useHttps;
        this.httpSender = new HttpSender();
        this.apiHostAndPath = "api.aylien.com/api/v1";
        this.rateLimits = new RateLimits();
    }

    public void setApiHostAndPath(String apiHostAndPath) {
        this.apiHostAndPath = apiHostAndPath;
    }


    /**
     * Detects sentiment of a body of text in terms of polarity
     * ("positive" or "negative") and subjectivity
     * ("subjective" or "objective").
     *
     * @param sentimentParams sentiment parameters
     * @return Sentiment.
     */
    public Sentiment sentiment(SentimentParams sentimentParams) throws TextAPIException {
        Map<String, String> parameters = new HashMap<String, String>();
        if (sentimentParams.getText() != null) {
            parameters.put("text", sentimentParams.getText());
        } else if (sentimentParams.getUrl() != null) {
            parameters.put("url", sentimentParams.getUrl().toString());
        } else {
            throw new IllegalArgumentException("You must either provide url or text");
        }

        if (sentimentParams.getMode() != null) {
            parameters.put("mode", sentimentParams.getMode());
            if (sentimentParams.getMode().equals("tweet") && sentimentParams.getLanguage() != null) {
                parameters.put("language", sentimentParams.getLanguage());
            }
        }

        Sentiment sentiment;
        try {
            String response = this.doHttpRequest("sentiment", transformParameters(parameters));

            JAXBContext jc = JAXBContext.newInstance(Sentiment.class);
            Unmarshaller u = jc.createUnmarshaller();

            JAXBElement<Sentiment> root = u.unmarshal(new StreamSource(new StringReader(response)), Sentiment.class);
            sentiment = root.getValue();
        } catch(Exception e) {
            throw new TextAPIException(e);
        }

        return sentiment;
    }

 private Map<String, List<String>> transformParameters(Map<String, String> parameters) {
        Map<String, List<String>> transformedParameters = new HashMap<String, List<String>>();
        for (Map.Entry<String, String> entry: parameters.entrySet()) {
            List<String> values = Arrays.asList(entry.getValue());
            transformedParameters.put(entry.getKey(), values);
        }

        return transformedParameters;
    }
    private String doHttpRequest(String endpoint, Map<String, List<String>> parameters) throws Exception {
        Map<String, String> headers = new HashMap<String, String>();
        headers.put("Accept", "text/xml");
        headers.put("X-AYLIEN-TextAPI-Application-ID", this.applicationId);
        headers.put("X-AYLIEN-TextAPI-Application-Key", this.applicationKey);

        String url = String.format("%s://%s/%s",
                (this.useHttps ? "https" : "http"),
                this.apiHostAndPath,
                endpoint
        );

        String response = this.httpSender.post(url, parameters, headers);
        Map<String, List<String>> responseHeaders = this.httpSender.getLastResponseHeaders();
        for (Map.Entry<String, List<String>> h: responseHeaders.entrySet()) {
            if (h.getKey() != null && h.getKey().startsWith("X-RateLimit-")) {
                String key = h.getKey();
                int value = Integer.parseInt(h.getValue().get(0));
                if (key.endsWith("-Limit")) this.rateLimits.setLimit(value);
                if (key.endsWith("-Remaining")) this.rateLimits.setRemaining(value);
                if (key.endsWith("-Reset")) this.rateLimits.setReset(value);
            }
        }

        return response;
    }

    public class RateLimits {
        private int limit;
        private int remaining;
        private int reset;

        public RateLimits() {
            new RateLimits(0, 0, 0);
        }

        public RateLimits(int limit, int remaining, int reset) {
            this.limit = limit;
            this.remaining = remaining;
            this.reset = reset;
        }

        public int getLimit() {
            return limit;
        }

        public void setLimit(int limit) {
            this.limit = limit;
        }

        public int getRemaining() {
            return remaining;
        }

        public void setRemaining(int remaining) {
            this.remaining = remaining;
        }

        public int getReset() {
            return reset;
        }

        public void setReset(int reset) {
            this.reset = reset;
        }
    }

    public RateLimits getRateLimits() {
        return this.rateLimits;
    }
}
