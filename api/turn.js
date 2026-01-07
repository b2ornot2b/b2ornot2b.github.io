export default function handler(req, res) {
  // CORS Configuration
  // In production, change '*' to your specific domain (e.g., 'https://b2-screen.vercel.app')
  res.setHeader('Access-Control-Allow-Credentials', true);
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET,OPTIONS');
  res.setHeader(
    'Access-Control-Allow-Headers',
    'X-CSRF-Token, X-Requested-With, Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Api-Version'
  );

  // Handle preflight requests
  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  const username = process.env.METERED_USERNAME;
  const credential = process.env.METERED_PASSWORD;

  if (!username || !credential) {
      console.error('Missing METERED_USERNAME or METERED_PASSWORD env vars');
      return res.status(500).json({ error: 'Server configuration error' });
  }

  const iceServers = [
      {
          urls: "stun:stun.relay.metered.ca:80",
      },
      {
          urls: "turn:in.relay.metered.ca:80",
          username: username,
          credential: credential,
      },
      {
          urls: "turn:in.relay.metered.ca:80?transport=tcp",
          username: username,
          credential: credential,
      },
      {
          urls: "turn:in.relay.metered.ca:443",
          username: username,
          credential: credential,
      },
      {
          urls: "turns:in.relay.metered.ca:443?transport=tcp",
          username: username,
          credential: credential,
      },
  ];

  res.status(200).json({ iceServers });
}
