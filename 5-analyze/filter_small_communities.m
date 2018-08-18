function track = filter_small_communities(track, len, siz)

stats = community_stats(track);
keep = find(stats.lifespan >= len & stats.com_max_size >= siz);
final_participation = NaN(size(stats.participation));
for i = 1:length(keep)
    final_participation(stats.participation == keep(i)) = i;
end
[communities, vertices] = participation_to_struct(final_participation);
track.communities = communities;
track.vertices = vertices;

end